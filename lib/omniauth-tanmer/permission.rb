require "faraday"
require "jwt"
module Omniauth
  module Tanmer
    class Permission
      attr_reader :app_id, :app_secret, :conn

      def initialize(oauth_host, app_id, app_secret)
        @app_id = app_id
        @app_secret = app_secret
        @conn = Faraday.new(oauth_host)
      end

      def remote_permissions
        return @remote_permissions if defined?(@remote_permissions)
        resp = conn.get('/api/v1/permissions.json', app_id: app_id, sn: generate_sn(SecureRandom.uuid))
        @remote_permissions = JSON.parse(resp.body).map(&:symbolize_keys)
      end

      def sync(permissions)
        puts "have #{permissions.size} permissions defined"
        puts "got #{remote_permissions.size} permissions from API"

        permissions_to_create = []
        permissions_to_destroy = []
        permissions_to_update = []

        compare_names = %i(name group_name subject_class subject_id action description)
        finder = %i(subject_class subject_id action)

        # create new
        permissions.each do |current_perm|
          unless remote_permissions.any? { |existing_perm| finder.all?{ |k| existing_perm[k] == current_perm[k] } }
            # permissions.delete(current_perm)
            permissions_to_create << current_perm
          end
        end
        puts "#{permissions_to_create.size} permissions will be created"
        permissions = permissions - permissions_to_create

        # destroy old
        remote_permissions.each do |existing_perm|
          unless permissions.any? { |current_perm| finder.all?{ |k| existing_perm[k] == current_perm[k] } }
            permissions_to_destroy << existing_perm
          end
        end
        puts "#{permissions_to_destroy.size} permissions will be deleted from API"
        remote_permissions = remote_permissions - permissions_to_destroy

        remote_permissions.each do |existing_perm|
          current_perm = permissions.find { |current_perm| finder.all?{ |k| existing_perm[k] == current_perm[k]} }
          unless compare_names.all? { |k| existing_perm[k] == current_perm[k] }
            permissions_to_update << [existing_perm[:id], current_perm]
          end
        end

        puts "#{permissions_to_update.size} permissions will be updated"

        permissions_to_destroy.each do |perm|
          resp = conn.delete("/api/v1/permissions/#{perm[:id]}", app_id: app_id, sn: generate_sn(app_secret, SecureRandom.uuid))
        end

        permissions_to_update.each do |id, perm|
          resp = conn.put("/api/v1/permissions/#{id}", permission: perm, app_id: app_id, sn: generate_sn(app_secret, SecureRandom.uuid))
        end

        permissions_to_create.each do |perm|
          resp = conn.post("/api/v1/permissions", permission: perm, app_id: app_id, sn: generate_sn(app_secret, SecureRandom.uuid))
          data = JSON.parse(resp.body)
        end
        {
          created: permissions_to_create,
          destroyed: permissions_to_destroy,
          updated: permissions_to_update
        }
      end

      private

      def generate_sn(data=nil)
        JWT.encode({ data: data, exp: Time.now.to_i + 300 }, app_secret, 'HS256')
      end
    end
  end
end
