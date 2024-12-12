#!/usr/bin/env ruby

require "pp"

def usage
  puts(
    <<~MSG
      $ slack-thread-format

      Takes in a Slack thread you selected and copied, and formats it to readable
      text.

      Reads from stdin, puts the result back in your clipboard:

        $ pbpaste | slack-thread-format | pbcopy

      Read from a file:

        $ cat /blah/file | slack-thread-format | pbcopy
    MSG
  )
end

unless ARGV.empty?
  puts(usage)
  exit(1)
end

raw_thread = $stdin.read.strip

# Collapse 4+ newlines in a row to 3.
raw_thread.gsub!(/\n\n\n\n+/, "\n\n\n")

# Get rid of " (edited)"
raw_thread.gsub!(" (edited)", "")

# Collapse emojis upwards to stay with their message
raw_thread.gsub!(/\n\n+(:\w+:\n)/, "\n\\1")

# Remove the replies line
raw_thread.gsub!(/\d+ (?:reply|replies)\n/, "")

# Split into each raw message
raw_messages = raw_thread.split(/\n{3}/).map(&:strip)

# Remove any messages that only have 1 line
raw_messages.reject! do |raw|
  raw.lines.size < 2
end

# Holds a single slack message
class Message
  attr_reader :username, :timestamp

  # rubocop:disable
  def initialize(raw)
    lines = raw.split(/\n/).map(&:strip)

    @username = lines.shift
    @timestamp = lines.shift.split("|")[0].strip

    @attachments = []

    # Find + extract any attachments
    lines.reject! do |line|
      if line.match?(/^.+\.\w{2,}$/)
        @attachments << line
        true
      else
        false
      end
    end

    @attachments.uniq!
    @reactions = {}

    # Extract any reactjis
    first_reactji_index = lines.index { |line| line.match?(/^:.+:$/) }

    if first_reactji_index
      # Slice out the emoji section
      emojis = lines[first_reactji_index..-1]
      lines = lines[0...first_reactji_index]

      emojis.each_slice(2) do |name, count|
        @reactions[name.strip] = count.to_i if count
      end
    end

    @message = lines.join("\n").strip
  end
  # rubocop:enable

  def to_formatted
    lines = ["@#{username} | #{@timestamp}"]
    lines << @message unless @message.empty?

    lines << "" if !@attachments.empty? || !@reactions.empty?

    @attachments.each do |attachment|
      lines << "(Attached #{attachment})"
    end

    unless @reactions.empty?
      reactions = []

      @reactions.each do |name, count|
        reactions << "#{count} #{name}"
      end

      lines << "[ #{reactions.join(" | ")} ]"
    end

    lines.join("\n")
  end
end

puts(
  raw_messages
    .map { |raw| Message.new(raw) }
    .map(&:to_formatted)
    .join("\n\n")
)
