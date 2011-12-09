require 'uri'

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  
  validates :email, :presence => true
  validates_uniqueness_of :email, :message => "Admin has already been created"
  
  devise :omniauthable, :token_authenticatable, :rememberable
  
  # validates_uniqueness_of :vinsol_id
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :remember_me
  
  def self.find_for_googleapps_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']
    if admin = Admin.where('email = ?', data['email']).first
      uri = URI.parse(access_token['uid'])
      v_id = uri.query.split(/=/)[1]
      if (!admin[:name] || admin[:name] != data['name']) && !admin[:vinsol_id]
        admin.update_attributes( :name => data['name'], :vinsol_id => v_id)
        return admin
      elsif admin[:vinsol_id] === v_id
        return admin
      else
        return false
      end
    else #create an admin with stub pwd
      return false
    end
  end
end
