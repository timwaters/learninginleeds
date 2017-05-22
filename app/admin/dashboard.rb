ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span "Adult Learning in Leeds Dashboard"
        small "This dashboard shows at a glance, recently edited records"
      end
    end

   
    columns do
      column do
        panel "Last 5 Recently Updated Courses" do
          ul do
            Course.order("updated_at desc").limit(5).map do |course|
              li link_to(course.title, admin_course_path(course)) 
              span "#{time_ago_in_words(course.updated_at)} ago"
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end
