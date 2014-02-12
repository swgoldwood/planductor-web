class Permission

  def initialize(user = nil)
    #admins and organisers
    if user and user.admin
      allow_all
    elsif user and user.organiser
      allow :competitions, [:new, :create]
      allow :competitions, [:edit, :update, :destroy] do |competition|
        competition.user_id == user.id
      end
      allow :domains, [:all]
    end

    #normal users
    if user
      allow :planners, [:new, :create]
      allow :planners, [:edit, :update, :destroy] do |planner|
        planner.user_id == user.id
      end
      allow :users, [:edit, :update, :destroy] do |user|
        user.id == user.id
      end
      allow :participants, [:create]
    end

    #guests
    allow [:competitions, :domains, :planners, :users, :sessions, :participants], [:index, :show]
    allow :sessions, [:create, :destroy, :new]
  end

  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]] || @allowed_actions[[controller.to_s, :all.to_s]]
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
