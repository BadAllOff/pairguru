class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    unless balanced?(record.title)
      record.errors[:title] << "Title is not valid"
    end
  end

  private

  def balanced?(title)
    stack = [] # Array to store opening brackets queue
    previous_char = ""
    brackets = { "{" => "}", "[" => "]", "(" => ")" }

    # Adds opening bracket at the end of the stack array.<
    # If char is a closing bracket, pops last opening bracket and checks if it matches.
    # If brackets match, checks if they aren't empty.
    title.each_char do |char|
      stack << char if brackets.key?(char)
      if brackets.key(char) &&
          (brackets.key(char) != stack.pop || brackets.key(char) == previous_char)
        return false
      end
      previous_char = char
    end

    # If all opened brackets were closed or there were no brackets returns true
    stack.empty?
  end
end

# this one fails only one test, but ... it looks really cool! :D
# non_delimiters = /[^(){}\[\]]*/
# Paired = /\(#{non_delimiters}\)|\{#{non_delimiters}\}|\[#{non_delimiters}\]/
# Delimiter = /[(){}\[\]]/
#
# def balanced? title
#   title = title.dup
#   title.gsub!(Paired, "".freeze) while title =~ Paired
#   title !~ Delimiter
# end
