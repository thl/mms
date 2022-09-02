# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220902172437) do

  create_table "administrative_unit_translations", force: true do |t|
    t.integer  "administrative_unit_id", null: false
    t.string   "locale",                 null: false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliations", force: true do |t|
    t.integer "medium_id",       null: false
    t.integer "sponsor_id"
    t.integer "organization_id", null: false
    t.integer "project_id"
  end

  add_index "affiliations", ["medium_id", "sponsor_id", "organization_id", "project_id"], name: "by_medium_sponsor_organization_project", unique: true, using: :btree

  create_table "application_filters", force: true do |t|
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_settings", force: true do |t|
    t.string  "title",         limit: 30, null: false
    t.text    "description"
    t.integer "value"
    t.integer "permission_id"
    t.string  "string_value"
  end

  add_index "application_settings", ["title"], name: "index_application_settings_on_title", unique: true, using: :btree

  create_table "cached_category_counts", force: true do |t|
    t.integer  "category_id",      null: false
    t.string   "medium_type"
    t.integer  "count",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cache_updated_at", null: false
  end

  add_index "cached_category_counts", ["category_id", "medium_type"], name: "index_cached_category_counts_on_category_id_and_medium_type", unique: true, using: :btree

  create_table "captions", force: true do |t|
    t.text     "title",               null: false
    t.integer  "description_type_id"
    t.integer  "creator_id"
    t.integer  "language_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "captions", ["title"], name: "title", type: :fulltext

  create_table "captions_media", id: false, force: true do |t|
    t.integer "medium_id",  null: false
    t.integer "caption_id", null: false
  end

  add_index "captions_media", ["medium_id", "caption_id"], name: "index_captions_media_on_medium_id_and_caption_id", unique: true, using: :btree

  create_table "capture_device_makers", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "exif_tag"
  end

  add_index "capture_device_makers", ["title"], name: "index_capture_device_makers_on_title", unique: true, using: :btree

  create_table "capture_device_models", force: true do |t|
    t.integer  "capture_device_maker_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "exif_tag"
  end

  add_index "capture_device_models", ["capture_device_maker_id", "title"], name: "index_capture_device_models_on_capture_device_maker_id_and_title", unique: true, using: :btree

  create_table "category_registered_theme_associations", force: true do |t|
    t.integer  "category_id",         null: false
    t.integer  "registered_theme_id", null: false
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_registered_theme_associations", ["category_id", "registered_theme_id"], name: "by_category_registered_theme", unique: true, using: :btree
  add_index "category_registered_theme_associations", ["permalink"], name: "index_category_registered_theme_associations_on_permalink", unique: true, using: :btree

  create_table "citations", force: true do |t|
    t.integer  "reference_id",             null: false
    t.string   "reference_type",           null: false
    t.integer  "creator_id"
    t.integer  "medium_id"
    t.integer  "page_number"
    t.string   "page_side",      limit: 5
    t.integer  "line_number"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comatose_page_versions", force: true do |t|
    t.integer  "comatose_page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type",      limit: 25, default: "Textile"
    t.string   "author"
    t.integer  "position",                    default: 0
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  add_index "comatose_page_versions", ["comatose_page_id"], name: "index_comatose_page_versions_on_comatose_page_id", using: :btree

  create_table "comatose_pages", force: true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", limit: 25, default: "Textile"
    t.string   "author"
    t.integer  "position",               default: 0
    t.integer  "version"
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "copyright_holders", force: true do |t|
    t.string "title",   limit: 250, null: false
    t.string "website"
  end

  add_index "copyright_holders", ["title"], name: "index_copyright_holders_on_title", unique: true, using: :btree

  create_table "copyrights", force: true do |t|
    t.integer "medium_id",            null: false
    t.integer "copyright_holder_id",  null: false
    t.integer "reproduction_type_id", null: false
    t.text    "notes"
  end

  add_index "copyrights", ["medium_id"], name: "index_copyrights_on_medium_id", unique: true, using: :btree

  create_table "country_translations", force: true do |t|
    t.integer  "country_id", null: false
    t.string   "locale",     null: false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creators_metadata_sources", id: false, force: true do |t|
    t.integer "creator_id",         null: false
    t.integer "metadata_source_id", null: false
  end

  create_table "cumulative_media_category_associations", force: true do |t|
    t.integer  "medium_id",   null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cumulative_media_category_associations", ["category_id", "medium_id"], name: "by_category_medium", unique: true, using: :btree

  create_table "cumulative_media_location_associations", force: true do |t|
    t.integer  "medium_id",  null: false
    t.integer  "feature_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cumulative_media_location_associations", ["feature_id", "medium_id"], name: "by_medium_location", unique: true, using: :btree

  create_table "definitions", force: true do |t|
    t.integer "definiendum_id",       null: false
    t.integer "definition_id",        null: false
    t.integer "grammatical_class_id"
    t.integer "loan_type_id"
    t.integer "dialect_id"
    t.integer "glossary_id"
  end

  add_index "definitions", ["definiendum_id", "definition_id", "glossary_id"], name: "index_by_definition_definiendum_and_glossary", unique: true, using: :btree

  create_table "definitions_keywords", id: false, force: true do |t|
    t.integer "definition_id", null: false
    t.integer "keyword_id",    null: false
  end

  add_index "definitions_keywords", ["definition_id", "keyword_id"], name: "index_definitions_keywords_on_definition_id_and_keyword_id", unique: true, using: :btree

  create_table "description_types", force: true do |t|
    t.string "title", limit: 100, null: false
  end

  add_index "description_types", ["title"], name: "index_description_types_on_title", unique: true, using: :btree

  create_table "descriptions", force: true do |t|
    t.text     "title",               null: false
    t.integer  "description_type_id"
    t.integer  "creator_id"
    t.integer  "language_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "descriptions", ["title"], name: "title", type: :fulltext

  create_table "descriptions_media", id: false, force: true do |t|
    t.integer "medium_id",      null: false
    t.integer "description_id", null: false
  end

  add_index "descriptions_media", ["medium_id", "description_id"], name: "index_descriptions_media_on_medium_id_and_description_id", unique: true, using: :btree

  create_table "dialects", force: true do |t|
    t.string "title", limit: 140, null: false
  end

  add_index "dialects", ["title"], name: "index_dialects_on_title", unique: true, using: :btree

  create_table "glossaries", force: true do |t|
    t.string  "title",                                     null: false
    t.text    "description"
    t.string  "abbreviation",    limit: 20
    t.integer "organization_id"
    t.boolean "is_public",                  default: true, null: false
  end

  add_index "glossaries", ["title"], name: "index_glossaries_on_title", unique: true, using: :btree

  create_table "grammatical_classes", force: true do |t|
    t.string "title", limit: 50, null: false
  end

  add_index "grammatical_classes", ["title"], name: "index_grammatical_classes_on_title", unique: true, using: :btree

  create_table "images", force: true do |t|
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
  end

  add_index "images", ["parent_id", "thumbnail"], name: "parent_id", using: :btree

  create_table "keyword_translations", force: true do |t|
    t.integer  "keyword_id", null: false
    t.string   "locale",     null: false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", force: true do |t|
    t.string "title", limit: 100, null: false
  end

  add_index "keywords", ["title"], name: "index_keywords_on_title", unique: true, using: :btree
  add_index "keywords", ["title"], name: "title", type: :fulltext

  create_table "languages", force: true do |t|
    t.string  "title",                   limit: 100,                 null: false
    t.string  "code",                    limit: 3,   default: "",    null: false
    t.string  "locale",                  limit: 6,   default: "",    null: false
    t.boolean "use_for_interface",                   default: false, null: false
    t.integer "unicode_codepoint_start"
    t.integer "unicode_codepoint_end"
  end

  add_index "languages", ["code"], name: "index_languages_on_code", unique: true, using: :btree
  add_index "languages", ["locale"], name: "index_languages_on_locale", unique: true, using: :btree
  add_index "languages", ["title"], name: "index_languages_on_title", unique: true, using: :btree

  create_table "letters", force: true do |t|
    t.string  "title", limit: 10, null: false
    t.integer "order"
  end

  create_table "loan_types", force: true do |t|
    t.string "title", limit: 15, null: false
  end

  add_index "loan_types", ["title"], name: "index_loan_types_on_title", unique: true, using: :btree

  create_table "locations", force: true do |t|
    t.integer "medium_id",                                       null: false
    t.text    "spot_feature"
    t.text    "notes"
    t.string  "type",         limit: 50
    t.integer "feature_id",                                      null: false
    t.decimal "lat",                     precision: 9, scale: 6
    t.decimal "lng",                     precision: 9, scale: 6
  end

  add_index "locations", ["medium_id", "feature_id"], name: "index_locations_on_medium_id_and_feature_id", unique: true, using: :btree

  create_table "media", force: true do |t|
    t.integer  "photographer_id"
    t.integer  "quality_type_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.text     "recording_note"
    t.text     "private_note"
    t.string   "type",                     limit: 20,                 null: false
    t.integer  "attachment_id"
    t.datetime "taken_on"
    t.integer  "recording_orientation_id"
    t.integer  "capture_device_model_id"
    t.string   "partial_taken_on"
    t.integer  "application_filter_id",                               null: false
    t.integer  "resource_type_id",                                    null: false
    t.integer  "rotation"
    t.boolean  "used_outside",                        default: false, null: false
  end

  add_index "media", ["type", "attachment_id"], name: "index_media_on_type_and_attachment_id", using: :btree

  create_table "media_category_associations", force: true do |t|
    t.integer  "medium_id",     null: false
    t.integer  "category_id",   null: false
    t.integer  "root_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "string_value"
    t.integer  "numeric_value"
  end

  add_index "media_category_associations", ["medium_id", "category_id"], name: "index_media_category_associations_on_medium_id_and_category_id", unique: true, using: :btree

  create_table "media_keyword_associations", force: true do |t|
    t.integer "medium_id",  null: false
    t.integer "keyword_id", null: false
  end

  add_index "media_keyword_associations", ["medium_id", "keyword_id"], name: "index_media_keyword_associations_on_medium_id_and_keyword_id", unique: true, using: :btree

  create_table "media_publishers", force: true do |t|
    t.integer  "publisher_id"
    t.integer  "medium_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_source_associations", force: true do |t|
    t.integer  "medium_id",   null: false
    t.integer  "source_id",   null: false
    t.integer  "shot_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_source_associations", ["medium_id", "source_id"], name: "index_media_source_associations_on_medium_id_and_source_id", unique: true, using: :btree

  create_table "metadata_sources", force: true do |t|
    t.string   "filename",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: true do |t|
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail",    limit: 10
    t.integer "width"
    t.integer "height"
    t.integer "status",                  default: 0
  end

  create_table "open_id_authentication_associations", force: true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", force: true do |t|
    t.integer "timestamp",  null: false
    t.string  "server_url", null: false
    t.string  "salt",       null: false
  end

  create_table "organizations", force: true do |t|
    t.string "title",   limit: 250, null: false
    t.string "website"
  end

  add_index "organizations", ["title"], name: "index_organizations_on_title", unique: true, using: :btree

  create_table "page_versions", force: true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", limit: 25, default: "Textile"
    t.string   "author"
    t.integer  "position",               default: 0
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "people", force: true do |t|
    t.string "fullname", null: false
  end

  add_index "people", ["fullname"], name: "index_people_on_fullname", unique: true, using: :btree

  create_table "permissions", force: true do |t|
    t.string "title",       limit: 60, null: false
    t.text   "description"
  end

  add_index "permissions", ["title"], name: "index_permissions_on_title", unique: true, using: :btree

  create_table "permissions_roles", id: false, force: true do |t|
    t.integer "permission_id", null: false
    t.integer "role_id",       null: false
  end

  add_index "permissions_roles", ["permission_id", "role_id"], name: "index_permissions_roles_on_permission_id_and_role_id", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string "title", limit: 250, null: false
  end

  add_index "projects", ["title"], name: "index_projects_on_title", unique: true, using: :btree

  create_table "publishers", force: true do |t|
    t.string   "title",      null: false
    t.integer  "place_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quality_types", force: true do |t|
    t.string "title", limit: 10, null: false
  end

  add_index "quality_types", ["title"], name: "index_quality_types_on_title", unique: true, using: :btree

  create_table "recording_orientations", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recording_orientations", ["title"], name: "index_recording_orientations_on_title", unique: true, using: :btree

  create_table "registered_themes", force: true do |t|
    t.string "title",       limit: 50, null: false
    t.text   "description"
    t.string "namespace",   limit: 10, null: false
    t.date   "created_on"
  end

  add_index "registered_themes", ["namespace"], name: "index_registered_themes_on_namespace", unique: true, using: :btree
  add_index "registered_themes", ["title"], name: "index_registered_themes_on_title", unique: true, using: :btree

  create_table "renderers", force: true do |t|
    t.string "title", limit: 50,  default: "", null: false
    t.string "path",  limit: 200,              null: false
  end

  add_index "renderers", ["path"], name: "index_renderers_on_path", unique: true, using: :btree
  add_index "renderers", ["title"], name: "index_renderers_on_title", unique: true, using: :btree

  create_table "reproduction_types", force: true do |t|
    t.string  "title",               null: false
    t.string  "website"
    t.integer "order",   default: 0, null: false
  end

  add_index "reproduction_types", ["title"], name: "index_reproduction_types_on_title", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string "title",       limit: 20, null: false
    t.text   "description"
  end

  add_index "roles", ["title"], name: "index_roles_on_title", unique: true, using: :btree

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true, using: :btree

  create_table "sources", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["title"], name: "index_sources_on_title", unique: true, using: :btree

  create_table "sponsors", force: true do |t|
    t.string "title", limit: 250, null: false
  end

  add_index "sponsors", ["title"], name: "index_sponsors_on_title", unique: true, using: :btree

  create_table "statuses", force: true do |t|
    t.string   "title",       null: false
    t.text     "description"
    t.integer  "position",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", force: true do |t|
    t.text     "title",       null: false
    t.integer  "creator_id"
    t.integer  "medium_id",   null: false
    t.integer  "language_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titles", ["title"], name: "title", type: :fulltext

  create_table "transformations", force: true do |t|
    t.integer "renderer_id",             null: false
    t.string  "title",       limit: 20,  null: false
    t.string  "path",        limit: 100, null: false
  end

  add_index "transformations", ["path"], name: "index_transformations_on_path", unique: true, using: :btree
  add_index "transformations", ["renderer_id", "title"], name: "index_transformations_on_renderer_id_and_title", unique: true, using: :btree

  create_table "translated_titles", force: true do |t|
    t.text     "title",       null: false
    t.integer  "creator_id"
    t.integer  "title_id",    null: false
    t.integer  "language_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translated_titles", ["title"], name: "title", type: :fulltext

  create_table "typescripts", force: true do |t|
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail",         limit: 10
    t.integer "width"
    t.integer "height"
    t.integer "transformation_id"
  end

  create_table "users", force: true do |t|
    t.integer  "person_id"
    t.string   "login",                     limit: 80, null: false
    t.string   "crypted_password",          limit: 40
    t.string   "identity_url"
    t.string   "email"
    t.string   "salt",                      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "shibboleth_id"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

  create_table "web_addresses", force: true do |t|
    t.string   "url",                null: false
    t.integer  "parent_resource_id"
    t.integer  "online_resource_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "words", force: true do |t|
    t.text    "title",       null: false
    t.integer "language_id", null: false
    t.integer "order"
    t.integer "letter_id"
  end

  add_index "words", ["title"], name: "title", type: :fulltext

  create_table "workflows", force: true do |t|
    t.integer  "medium_id",            null: false
    t.string   "original_filename"
    t.text     "original_medium_id",   null: false
    t.string   "other_id"
    t.string   "notes"
    t.integer  "sequence_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.integer  "processing_status_id"
    t.integer  "metadata_source_id"
    t.text     "original_path"
  end

  add_index "workflows", ["medium_id"], name: "index_workflows_on_medium_id", unique: true, using: :btree
  add_index "workflows", ["original_medium_id"], name: "original_medium_id", type: :fulltext

end
