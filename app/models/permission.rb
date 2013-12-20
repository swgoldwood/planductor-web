class Permission

  def initialize(user = nil)
    if user and user.admin
      allow_all
    elsif user and user.organiser
      allow :competitions, [:new, :create]
      allow :competitions, [:edit, :update, :destroy] do |comp|
        comp.user_id == user.id
      end
      allow :domains, [:all]
    end
    allow [:competitions, :domains], [:index, :show]
    allow [:planners, :users, :sessions, :participants], [:all]
  end

  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]] ||
                @allowed_actions[[controller.to_s, :all.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end

  def allow_all
    @allow_all = true
  end

  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

end
