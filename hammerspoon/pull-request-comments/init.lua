-- https://conventionalcomments.org/

local labels = {
  {
    name = 'praise',
    description = 'Praises highlight something positive. Try to leave at least one of these comments per review. Do not leave false praise (which can actually be damaging). Do look for something to sincerely praise.',
  },
  {
    name = 'nitpick',
    description = "Nitpicks are small, trivial, but necessary changes. Distinguishing nitpick comments significantly helps direct the reader's attention to comments requiring more involvement.",
  },
  {
    name = 'suggestion',
    description = "Suggestions propose improvements to the current subject. It's important to be explicit and clear on what is being suggested and why it is an improvement. Consider using patches and the blocking or non-blocking decorations to further communicate your intent.",
  },
  {
    name = 'issue',
    description = 'Issues highlight specific problems with the subject under review. These problems can be user-facing or behind the scenes. It is strongly recommended to pair this comment with a suggestion. If you are not sure if a problem exists or not, consider leaving a question.',
  },
  {
    name = 'question',
    description = "Questions are appropriate if you have a potential concern but are not quite sure if it's relevant or not. Asking the author for clarification or investigation can lead to a quick resolution.",
  },
  {
    name = 'thought',
    description = 'Thoughts represent an idea that popped up from reviewing. These comments are non-blocking by nature, but they are extremely valuable and can lead to more focused initiatives and mentoring opportunities.',
  },
  {
    name = 'chore',
    description = 'Chores are simple tasks that must be done before the subject can be “officially” accepted. Usually, these comments reference some common process. Try to leave a link to the process description so that the reader knows how to resolve the chore.',
  },
}

local decorations = {
  {
    name = 'non-blocking',
    description = 'A comment with this decoration should not prevent the subject under review from being accepted. This is helpful for organizations that consider comments blocking by default.',
  },
  {
    name = 'blocking',
    description = 'A comment with this decoration should prevent the subject under review from being accepted, until it is resolved. This is helpful for organizations that consider comments non-blocking by default.',
  },
  {
    name = 'if-minor',
    description = 'This decoration gives some freedom to the author that they should resolve the comment only if the changes ends up being minor or trivial.',
  },
}

local function buildInitialState()
  return {
    status = 'untriggered', -- untriggered, waiting_for_label, waiting_for_decorations
    label = nil,
    decorations = {},
  }
end

local state = buildInitialState()
