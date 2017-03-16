# bootstrap を使って、flash を表示するための helper
module ApplicationHelper::Flash

  def show_success(flash)
    if flash && flash[:success]
      html = <<-"HTML"
      <div class="alert alert-success alert-dismissible" role="alert">
        <button aria-label="Close" class="close" data-dismiss="alert" type="button">
          <span aria-hidden="true"> &times;</span>
        </button>
        #{flash[:success]}
      </div>
      HTML
      html.html_safe
    else
      ''
    end
  end

  def show_error (flash)
    if flash && flash[:error]
      html = <<-"HTML"
      <div class="alert alert-danger alert-dismissible" role="alert">
        <button aria-label="Close" class="close" data-dismiss="alert" type="button">
          <span aria-hidden="true"> &times;</span>
        </button>
        #{flash[:error]}
      </div>
      HTML
      html.html_safe
    else
      ''
    end
  end

end
