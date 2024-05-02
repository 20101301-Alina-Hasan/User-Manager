class UsersController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    # Action to list users
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def bulk_update
     # Action to handle bulk actions: (block, unblock, delete)
     action = params[:commit] # Get the name of the button clicked
     user_ids = params[:user_ids] || [] # Get the array of selected user IDs
     puts "[1] bulk_update: Selected user IDs to block: #{user_ids.inspect}"
    case action
      when "Block"
        block(user_ids)
      when "Unblock"
        unblock(user_ids)
      when "Delete"
        destroy(user_ids)
      end
      redirect_to users_path # Refresh Page
   end

  private

  def block(user_ids)
    # Action to block a user
    puts "[2] block: Selected user IDs to block: #{user_ids.inspect}"
    
    @selected_users = User.where(id: params.fetch(:user_ids, []).compact)
    @selected_users.update_all(status: false) # Assuming status is a boolean field representing user's blocked status
 
    puts "Current User ID: #{session[:user_id]}"
    if user_ids.include?(session[:user_id].to_s)
      # Log out the current user if they are blocking themselves
      reset_session
    end
    
    unless @selected_users.count == 1
      flash[:notice] = "#{@selected_users.count} users blocked successfully."
    else
      flash[:notice] = "#{@selected_users.count} user blocked successfully."
    end
  end
  

  def unblock(user_ids)
    # Action to unblock a user
    puts "[3] unblock: Selected user IDs to block: #{user_ids.inspect}"
    @selected_users = User.where(id: params.fetch(:user_ids, []).compact)
    @selected_users.update_all(status: true) # Assuming status is a boolean field representing user's blocked status
    unless @selected_users.count == 1
      flash[:notice] = "#{@selected_users.count} users unblocked successfully."
    else
      flash[:notice] = "#{@selected_users.count} user unblocked successfully."
    end
  end

  def destroy(user_ids)
    # Action to delete a user
    puts "[4] destroy: Selected user IDs to block: #{user_ids.inspect}"
    @selected_users = User.where(id: user_ids)
    deleted_users_count = @selected_users.count
    @selected_users.destroy_all

    puts "Current User ID: #{session[:user_id]}"
    if user_ids.include?(session[:user_id].to_s)
      # Log out the current user if they are blocking themselves
      reset_session
    end

    unless deleted_users_count == 1
      flash[:notice] = "#{deleted_users_count} users deleted successfully."
    else
      flash[:notice] = "#{deleted_users_count} user deleted successfully."
    end
  end

  def require_login
    unless session[:user_id]
    flash[:alert] = "You must be logged in to access this page."
    redirect_to login_path
    end
  end

end
