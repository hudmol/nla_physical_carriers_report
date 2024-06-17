# check config for subjects to match on
# default: ['born digital', 'audio', 'moving image']
unless AppConfig.has_key?(:nla_physical_carriers_report_subjects)
  AppConfig[:nla_physical_carriers_report_subjects] = ['born digital', 'audio', 'moving image']
end

subjects = AppConfig[:nla_physical_carriers_report_subjects]
nonexistent_subjects = []

subjects.each do |subject|
  unless Subject[:title => subject]
    nonexistent_subjects << subject
  end
end

if subjects.empty?
  Log.error("ERROR: nla_physical_carriers_report plugin is badly configured! It has no subjects. Use AppConfig[:nla_physical_carriers_report_subjects] to set an array of subjects, or don't set it to accept the default: ['born digital', 'audio', 'moving image']")
elsif nonexistent_subjects.empty?
  Log.info("nla_physical_carriers_report plugin is correctly configured with subjects: #{subjects.join(', ')}")
else
  Log.error("ERROR: nla_physical_carriers_report plugin is badly condfigured! Non-existent subjects: #{nonexistent_subjects.join(', ')}")
end
