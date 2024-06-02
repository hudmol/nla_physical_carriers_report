class PhysicalCarriersReport < AbstractReport

  subjects = AppConfig[:nla_physical_carriers_report_subjects] rescue ['born digital', 'audio', 'moving images']

  subject_params = subjects.map {|subject| [subject, 'Boolean', 'Subject: ' + subject, { optional: true }]}

  repo_params = Repository.filter(Sequel.~(:repo_code => '_archivesspace'))
    .select(:repo_code).map{|repo| [repo[:repo_code], 'Boolean', 'Repository: ' + repo[:repo_code], { optional: true }]}

  register_report({
                    :uri_suffix => "nla_physical_carriers",
                    :description => "Physical Carriers Report",
                    :params => [
                      ["resource_uri", "resource_linker", "Limit to Resource", { optional: true }]
                    ] + subject_params + [[" ", "nonce", " ", { optional: true }]] + repo_params
                  })

  def initialize(params, job, db)
    super
puts 'QQQQQQQQQ  ' + params.to_s
    if resource_uri = params['resource_uri']
      @resource_id = JSONModel.parse_reference(resource_uri)[:id]
    end

    # annoyingly the subject params aren't distinguished in any way
    subject_params = params.select{|k,v| k != 'resource_uri' && k != :format && k != :repo_id && k != 'csv_show_json'}

    info[:subjects] = subject_params.keys.join(', ')

    @subject_ids = []

    subject_params.each do |subject, _|
      if subject_id = db[:subject].filter(:title => subject).get(:id)
        @subject_ids << subject_id
      else
        job.write_output('WARNING: No subject found for "' + subject + '"')
      end
    end

    if @subject_ids.empty?
      raise "ERROR: No subjects found!"
    end
  end

  def title
    "Physical Carriers"
  end

  def query
    dataset = db[:archival_object]

    if @resource_id
      dataset = dataset.filter(:root_record_id => @resource_id)
    end


    dataset = dataset.inner_join(:subject_rlshp, :archival_object__id => :subject_rlshp__archival_object_id)
                     .filter(:subject_rlshp__subject_id => @subject_ids)
                     .left_join(Sequel.as(:enumeration_value, :level_enum), :level_enum__id => :archival_object__level_id)
                     .inner_join(:subject, :subject_rlshp__subject_id => :subject__id)
                     .inner_join(:repository, :repository__id => :archival_object__repo_id)
                     .left_join(:extent, :extent__archival_object_id => :archival_object__id)
                     .left_join(Sequel.as(:enumeration_value, :extent_portion_enum), :extent_portion_enum__id => :extent__portion_id)
                     .left_join(Sequel.as(:enumeration_value, :extent_type_enum), :extent_type_enum__id => :extent__extent_type_id)
                     .left_join(:date, :date__archival_object_id => :archival_object__id)
                     .left_join(:instance, :instance__archival_object_id => :archival_object__id)
                     .left_join(Sequel.as(:enumeration_value, :instance_type_enum), :instance_type_enum__id => :instance__instance_type_id)
                     .left_join(:sub_container, :sub_container__instance_id => :instance__id)
                     .left_join(:top_container_link_rlshp, :top_container_link_rlshp__sub_container_id => :sub_container__id)
                     .left_join(:top_container, :top_container__id => :top_container_link_rlshp__top_container_id)
                     .left_join(Sequel.as(:enumeration_value, :top_con_type_enum), :top_con_type_enum__id => :top_container__type_id)
                     .left_join(:top_container_housed_at_rlshp, :top_container__id => :top_container_housed_at_rlshp__top_container_id)
                     .left_join(:location, :top_container_housed_at_rlshp__location_id => :location__id)
                     .distinct(:archival_object__id)
                     .select(
                             :archival_object__id,
                             :archival_object__component_id,
                             :archival_object__title,
                             Sequel.as(:level_enum__value, :level),
                             Sequel.as(:repository__repo_code, :repository),
                             :archival_object__repository_processing_note,
                             Sequel.as(:extent_portion_enum__value, :"extent portion"),
                             Sequel.as(:extent__number, :"extent number"),
                             Sequel.as(:extent_type_enum__value, :"extent type"),
                             Sequel.as(:extent__physical_details, :"extent physical details"),
                             Sequel.as(:extent__dimensions, :"extent dimensions"),
                             Sequel.as(:date__begin, :"begin date"),
                             Sequel.as(:date__end, :"end date"),
                             Sequel.as(:subject__title, :subject),
                             Sequel.as(:instance_type_enum__value, :"instance type"),
                             Sequel.as(:top_con_type_enum__value, :"top container type"),
                             Sequel.as(:top_container__indicator, :"top container indicator"),
                             Sequel.as(:location__title, :"top container location"),
                             )

    dataset
  end

end
