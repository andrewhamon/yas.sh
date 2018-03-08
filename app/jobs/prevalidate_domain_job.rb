class PrevalidateDomainJob < ApplicationJob
  def run(site_id)
    site = Site.find(site_id)

    return if site.domain_recently_prevalidated?

    ActiveRecord::Base.transaction do
      site.perform_domain_prevalidation!
      destroy
    end
  end
end
