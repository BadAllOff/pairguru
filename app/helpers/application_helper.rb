module ApplicationHelper
  def link_to_delete_comment(commentable, comment)
    if user_signed_in? && current_user.author_of?(comment)
      link_to 'Delete', [commentable, comment], method: :delete, class: 'btn btn-xs btn-danger', data: { confirm: 'Are you sure?'}
    end
  end

end
