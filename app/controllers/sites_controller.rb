class SitesController < ApplicationController
  skip_before_action :authenticate, only: [:prevalidate]

  def index
    render_json(current_user.sites.order(domain: :asc), root: :sites)
  end

  def show
    site = current_user.sites.find_by!(domain: params[:id])
    render_json(site, root: :site)
  end

  def create
    result = CreateSite.call(current_user: current_user, params: site_params)


    if result.success?
      render_json(result.site, status: result.status, root: :site)
    else
      render_errors(result.site)
    end
  end

  def prevalidate
    site = Site.find_by!(domain_prevalidation_token: params[:domain_prevalidation_token])
    render plain: site.domain_prevalidation_content
  end

  private

  def site_params
    params.permit(:domain)
  end
end
