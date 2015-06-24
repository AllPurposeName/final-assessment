module ApplicationHelper

  def language_form
    form_for("Languages", url: "/information") do |f|
      Language.all.where(preferred: false).map do |lang|
        f.check_box(lang.name, {}, {multiple: true}, 0)
        f.label(lang.name, lang.name, {multiple: true})
      end
      f.submit
    end
  end
end
