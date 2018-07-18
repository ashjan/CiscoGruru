namespace :data do

  desc "sets old schemata database type to generic"
  task :set_db_types => :environment do
    Schema.update_all db: 'generic'
  end

  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "Error: cannot drop production database"
    end
  end

  desc "Reset"
  task :reset => [:ensure_development_environment, "db:drop", "db:create", "db:migrate", "db:seed", "app:populate"]

  desc "Populate the database with development data"
  task :populate => :environment do
    User.create(:username => "cenan", :email => "cenan.ozen@gmail.com", :password => "test", :password_confirmation => "test")
    puts "Created 'cenan' user"
  end

  # Temporary task for setting autoincrement properties of existing primary key fields
  # This should only be run once on production
  desc "Set autoincrement fields for primary keys"
  task :set_autoincrement_fields => :environment do
    Schema.find_each do |schema|
      puts "Processing schema: #{schema.id}"
      data = JSON.parse(schema.schema_data)
      next unless data['tables']
      data['tables'] = data['tables'].map do |table|
        next unless table['fields']
        table['fields'] = table['fields'].map do |field|
          if field['pk']
            field['auto_increment'] = true
          end
          field
        end
        table
      end
      schema.update schema_data: data.to_json
    end
  end

  task :tmp_gen_yaml => :environment do
    Schema.find_each do |schema|
      data = JSON.parse(schema.schema_data)
      data['tables'].each do |table|
        puts table['name']
        table['fields'].each do |field|
          puts "  #{field['name']}\t#{field['pk']}"
        end
      end
    end
  end

  # Converts old schemata xml dump format
  desc "Import old schemata data from xml dump"
  task :import_old_schemata => :environment do
    puts "Old schemata are already imported"
    puts "Modify data.rake to run this task"
    return
    if Rails.env.production?
      XML_FILE_PATH = "/home/deployer/download_schemata.xml"
    else
      XML_FILE_PATH = "tmp/download_schemata.xml"
    end
    f = File.open(XML_FILE_PATH)
    doc = Nokogiri::XML(f) do |config|
      config.strict
    end
    f.close
    Schema.where(id: OldSchema.where(imported: true).pluck(:id)).destroy_all
    OldSchema.delete_all
    schemata = doc.xpath '/dbdsgnr/Schemata/Schema'
    schemata.each_with_index do |schema, idx|
      sd = JSON.parse(schema.xpath('./data').first.text)
      sd["title"] = sd["name"]
      sd.except!("name")
      sd["db"] = sd["databaseEngine"]
      sd.except!("databaseEngine")
      sd["tables"].each do |table|
        table['fields'].each do |field|
          old_type = field['type']
          field['type'] = get_field_name(sd["db"], field['type'])
          unless field['type']
            puts "#{sd['db']} #{old_type} not found"
          end
          if field['pk'] == 1
            field['pk'] = true
          else
            field.except!("pk")
          end
          if field['fk'] == 1
            field['fk'] = true
          else
            field.except!("fk")
          end
          field['fk_table'] = field['fkname']
          field['fk_field'] = field['fkfield']
          field.except!("fkname")
          field.except!("fkfield")
        end
      end
      unless sd.key? 'notes'
        sd['notes'] = []
      end
      OldSchema.create({
        username: schema.xpath('./author').first.text,
        name: schema.xpath('./name').first.text,
        db: sd['db'],
        schema_data: sd.to_json,
        template: schema.xpath('./template').first.text == "True",
        import_date: DateTime.parse(schema.xpath('./date').first.text)
        })
      puts "importing #{idx}"
    end
  end

  def get_field_name(db, field_num)
    datatypes = {
      "mysql" => {
          100 => "int",
          101 => "tinyint",
          102 => "smallint",
          103 => "mediumint",
          104 => "bigint",
          105 => "float",
          106 => "double",
          107 => "decimal",
          108 => "bit",
          109 => "char",
          110 => "varchar",
          111 => "tinytext",
          112 => "text",
          113 => "mediumtext",
          114 => "longtext",
          115 => "binary",
          116 => "varbinary",
          117 => "tinyblob",
          118 => "blob",
          119 => "mediumblob",
          120 => "longblob",
          121 => "enum",
          122 => "set",
          123 => "date",
          124 => "datetime",
          125 => "time",
          126 => "timestamp",
          127 => "year"
      },
      "sqlite" => {
          300 => "integer",
          301 => "real",
          302 => "text",
          303 => "numeric",
          304 => "blob"
      },
      "postgres" => {
          200 => "char",
          201 => "abstime",
          202 => "aclitem",
          203 => "bigint",
          204 => "bit",
          205 => "bit varying",
          206 => "boolean",
          209 => "bytea",
          210 => "character",
          211 => "character varying",
          # 212 => "cid",
          213 => "cidr",
          214 => "circle",
          215 => "date",
          216 => "double precision",
          # 217 => "gtsvector",
          212 => "inet",
          217 => "integer",
          218 => "interval",
          221 => "macaddr",
          222 => "money",
          223 => "numeric",
          220 => "oid",
          224 => "path",
          225 => "point",
          226 => "polygon",
          227 => "real",
          228 => "refcursor",
          229 => "regclass",
          230 => "regconfig",
          231 => "regdictionary",
          232 => "regoper",
          233 => "regoperator",
          234 => "regproc",
          235 => "regprocedure",
          236 => "regtype",
          237 => "reltime",
          238 => "smallint",
          239 => "smgr",
          240 => "text",
          241 => "tid",
          242 => "time with time zone",
          243 => "time without time zone",
          244 => "timestamp with time zone",
          245 => "timestamp without time zone",
          246 => "tinterval",
          247 => "tsquery",
          248 => "tsvector",
          249 => "txid_snapshot",
          250 => "uuid",
          251 => "xid",
          252 => "xml",
          253 => "serial",
          254 => "bigserial"
      },
      "oracle" => {
          400 => "bool",
          401 => "int",
          402 => "real",
          403 => "number",
          404 => "decimal",
          405 => "double",
          410 => "char",
          411 => "nchar",
          412 => "varchar",
          413 => "string",
          420 => "date",
          421 => "datetime",
          422 => "timestamp",
          430 => "blob",
          431 => "bfile",
          432 => "clob",
          433 => "nclob",
          440 => "rowid",
          441 => "urowid"
      },
      "mssql" => {
          500 => "bigint",
          501 => "binary",
          502 => "bit",
          503 => "char",
          504 => "datetime",
          505 => "decimal",
          506 => "float",
          507 => "image",
          508 => "int",
          509 => "money",
          510 => "nchar",
          511 => "ntext",
          512 => "numeric",
          513 => "nvarchar",
          514 => "real",
          515 => "smalldatetime",
          516 => "smallint",
          517 => "smallmoney",
          518 => "sql_variant",
          519 => "text",
          520 => "timestamp",
          521 => "tinyint",
          522 => "uniqueidentifier",
          523 => "varbinary",
          524 => "varchar",
          525 => "xml"
      }
    }
    datatypes[db][field_num.to_i]
  end
end