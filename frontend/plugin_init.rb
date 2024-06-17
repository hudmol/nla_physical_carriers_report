# default: ['born digital', 'audio', 'moving image']
unless AppConfig.has_key?(:nla_physical_carriers_report_subjects)
  AppConfig[:nla_physical_carriers_report_subjects] = ['born digital', 'audio', 'moving image']
end
