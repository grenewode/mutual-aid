class Importers::CommunityResourceImporter < Importers::BaseImporter
  def primary_import_klass_name
    "CommunityResource"
  end

  def process_row(row)
    puts "Pair programming @ RFG!!!"
    comm_resource = CommunityResource.create! name: row["name"], website_url: row["website_url"], facebook_url: row["facebook_url"], phone: row["phone"], description: row["description"], youtube_identifier: row["youtube_identifier"], publish_from: row["publish_from"], publish_until: row["publish_until"], is_created_by_admin: row["is_created_by_admin"], is_approved: row["is_approved"]

    comm_resource.tag_list.add(row["category_name"])

    comm_resource.organization = Organization.create! name: row["organization_name"]
    business_location = LocationType.find_or_create_by(name: "business")
    comm_resource.location = Location.create! do |location|
      location.street_address = row["street"]
      location.city = row["city"]
      location.state = row["state"]
      location.zip = row["zip"]
      location.county = row["county"]
      location.location_type = business_location
    end

    service_location_type = LocationType.find_or_create_by(name: "service_area")
    comm_resource.service_area = ServiceArea.create! do |service_area|
      if row["service_area_name"]
        service_area.name = row["service_area_name"]
      elsif row["service_area_town_names"]
        service_area.name = row["service_area_town_names"]
      elsif row["service_area_counties"]
        service_area.name = row["service_area_counties"]
      else
        service_area.name = row["city"]
      end

      if row["service_area_counties"]
        service_area.service_area_type = "county"
      else
        service_area.service_area_type = "city"
      end

      service_area.organization = comm_resource.organization
      service_area.location = Location.create! do |location|
        location.location_type = service_location_type

        location.city = row["service_area_town_names"] ? row["service_area_town_names"] : row["city"]

        location.state = row["state"]

        location.county = row["service_area_counties"] ? row["service_area_counties"] : row["county"]
      end
    end

    comm_resource.save
  end
end