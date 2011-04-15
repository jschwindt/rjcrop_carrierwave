class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      if params[:user][:image].present?
        render :action => 'cropping'
      else
        redirect_to(@user, :notice => 'User was successfully created.')
      end
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      if params[:user][:image].present?
        render :action => 'cropping'
      else
        redirect_to(@user, :notice => 'User was successfully updated.')
      end
    else
      render :action => "edit"
    end
  end

  def crop
    @user = User.find(params[:id])
    render :action => 'cropping'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url)
  end
end
