# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :set_roles, only: %i[index list]
  before_action :set_role, only: %i[show edit update destroy apply_permission]
  before_action :set_permissions, only: %i[show apply_permission]

  # GET /roles or /roles.json
  def index; end

  def list
    render(partial: 'roles/table', locals: { roles: @roles })
  end

  # GET /roles/1 or /roles/1.json
  def show; end

  # GET /roles/new
  def new
    authorize Role
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit; end

  # POST /roles or /roles.json
  def create
    @role = Role.new(role_params)
    authorize @role

    respond_to do |format|
      if @role.save
        flash[:success] = 'Role was successfully created.'
        format.html { redirect_to role_url(@role), notice: 'Role was successfully created.' }
      else
        flash[:error] = 'Role not created.'
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        flash[:success] = 'Role was successfully updated'
        format.html { redirect_to role_url(@role), notice: 'Role was successfully updated.' }
      else
        flash[:error] = 'Role not updated.'
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def apply_permission
    permission = @role.permissions.find_by(key: params[:key], action: params[:p_action])
    if permission.present?
      @role.permissions.delete(permission)
    else
      @role.permissions << Permission.find_by(key: params[:key], action: params[:p_action])
    end
    render(partial: 'permissions/table', locals: { permissions: @permissions })
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    respond_to do |format|
      if @role.destroy
        flash[:success] = 'Role was successfully destroyed.'
      else
        flash[:error] = 'Role not destroyed.'
      end
      format.html { redirect_to roles_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])

    authorize @role
  end

  def set_permissions
    @permissions = Permission.group(:key).map do |permission|
      OpenStruct.new(
        key: permission.key,
        permissions: Permission.where(key: permission.key)
      )
    end
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:id, :name, :description, :code, :active)
  end

  def set_roles
    authorize Role
    @roles = Role.all
    sort_roles
    @pagy, @roles = pagy(@roles)
  end

  def allow_sort
    %w[id name code].include?(params[:sort_by].to_s)
  end

  def sort_roles
    return unless allow_sort

    sort = { params[:sort_by].to_sym => params[:sort_order] == 'DESC' ? 'DESC' : 'ASC' }

    @roles = @roles.order(sort)
  end
end
