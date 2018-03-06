class CreateSite
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      context.site = context.current_user.account.sites.find_or_initialize_by(domain: context.params[:domain])
      context.status = context.site.new_record? ? :created : :ok

      context.site.save!
      context.site.enqueue_domain_prevalidation!
    end
  end
end
