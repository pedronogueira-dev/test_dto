class UsersController < ApplicationController
  before_action :set_user, only: [ :show ]
  def index
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 20).to_i.clamp(1, 200)

    result = Users::ListService.call(requester: current_user, page:, per_page:)
    case
    when result.success
      @users  = result.data[:users]
      @meta   = result.data[:meta]
      respond_to do |format|
        format.html # renders index.html.erb
        format.turbo_stream  do
          render "users/streams/index", formats: :turbo_stream # optional stream updates for pagination
        end
      end
    when result.errors == :forbidden
      head :forbidden
    else
      head :internal_server_error
    end
  end

  def show
    result = Users::FetchProfileService.call(requester: current_user, user_id: @user.id)

    if result.success
      @user_hash = result.data # already a hash
      respond_to do |format|
        format.turbo_stream do
          render "users/streams/show", formats: :turbo_stream # optional stream updates for pagination
        end# show.turbo_stream.erb -> fills modal frame
        format.html # show.html+turbo_frame.erb (direct frame render)
      end
    else
      head(result.errors == :forbidden ? :forbidden : :not_found)
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.turbo_stream # renders users/new.turbo_stream.erb (modal open)
      format.html { redirect_to users_path } # fallback
    end
  end

  def create
    result = Users::CreateService.call(requester: current_user, params: user_params)
    if result.success
      @user_hash = result.data # hash shaped like Dto (id/name/email[/access_token])
      respond_to do |format|
        format.turbo_stream # renders users/create.turbo_stream.erb
        format.html { redirect_to users_path, notice: "User created" }
      end
    else
      @user = User.new(user_params)
      @errors = Array(result.errors)
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity } # re-render modal
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # adjust to your model
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation, :role)
  end
end
