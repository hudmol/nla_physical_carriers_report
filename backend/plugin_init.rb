# check config for subjects to match on
# default: ['born digital', 'audio', 'moving images']

subjects = AppConfig[:nla_physical_carriers_report_subjects] rescue ['born digital', 'audio', 'moving images']
nonexistent_subjects = []

subjects.each do |subject|
  if sub_obj = Subject[:title => subject]

  else
    nonexistent_subjects << subject
  end
end

if subjects.empty?
  Log.info("ERROR: nla_physical_carriers_report plugin is badly configured! It has no subjects. Use AppConfig[:nla_physical_carriers_report_subjects] to set an array of subjects")
elsif nonexistent_subjects.empty?
  Log.info("nla_physical_carriers_report plugin is correctly configured with subjects: #{subjects.join(', ')}")
else
  raise "ERROR: nla_physical_carriers_report plugin is badly condfigured! Nonexistent subjects: #{nonexistent_subjects.join(', ')}"
end
