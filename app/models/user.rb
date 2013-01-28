class User < ActiveRecord::Base
  attr_accessible nil
  validates_presence_of :email, :name, :token, :uid, :cal_token
  before_validation :set_cal_token, on: :create

  def self.find_or_create_by_auth_hash!(auth_hash)
    record = find_by_uid(auth_hash.uid) || new
    record.uid = auth_hash.uid
    record.name = auth_hash.info.name
    record.email = auth_hash.info.email
    record.token = auth_hash.credentials.token
    record.save!
    record
  end

  private

  def set_cal_token
    self.cal_token = SecureRandom.hex(16)
  end
end
