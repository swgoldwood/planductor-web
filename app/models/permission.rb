class Permission

  def initialize(user = nil)
    #admins and organisers
    if user and user.admin

      #admins have full access
      allow_all
    elsif user and user.organiser

      #organisers can create competitions
      allow :competitions, [:new, :create]

      #organisers can edit and destroy their own competitions
      allow :competitions, [:edit, :update, :destroy] do |competition|
        competition.user_id == user.id
      end

      #organisers have full access on domains
      allow :domains, [:all]
    end

    #normal users
    if user

      #users can add planners
      allow :planners, [:new, :create]

      #users can edit their own planners if it is not a participant in a competition
      allow :planners, [:edit, :update] do |planner|
        planner.user_id == user.id and planner.competitions.count == 0
      end

      #users can destroy their own planners
      allow :planners, [:destroy] do |planner|
        planner.user_id == user.id
      end

      #users can edit and destroy themselves
      allow :users, [:edit, :update, :destroy] do |user|
        user.id == user.id
      end

      #users can add participants to competitions
      allow :participants, [:create]
    end

    #guests can see all through index and show methods
    allow [:competitions, :domains, :problems, :planners, :users, :participants], [:index, :show]

    #guests can create and destroy sessions (sign in/ sign out)
    allow :sessions, [:all]

    #guests can register
    allow :users, [:new, :create]

    #guests can go to all static pages
    allow :static_pages, [:all]
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
