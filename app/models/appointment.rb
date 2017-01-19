require 'webmock'
require 'rest-client'
require 'nokogiri'
include WebMock::API
WebMock.enable!
WebMock.allow_net_connect!

class Appointment < ApplicationRecord
  validates :id_number, presence: true, format: { with: /\A[1-9][0-9]{16}[0-9X]\Z/ }

  validates :phone_number, presence: true, format: { with: /\A1\d{10}\Z/ }

  belongs_to :business_category

  before_validation :upcase_id_number

  validate :has_unexpired_appointment,
           :in_today,
           :in_limitation,
           :get_appointment_from_machine

  private

  def has_unexpired_appointment
    if Appointment.where(id_number: id_number, expired: false).exists?
      errors.add(:id_number, "you have unexpired appointment")
    end
  end

  def in_today
    if appoint_at < Date.today || appoint_at > 5.days.from_now
      errors.add(:appoint_at, "your appoint is not in today")
    end
  end

  def in_limitation
    limitation = Setting.first&.limitation
    finished = Appointment.where(appoint_at: Date.today).count
    if limitation - finished < 0
      errors.add(:id_number, "the people number is reaching limitation")
    end
  end

  def get_appointment_from_machine
    s = Setting.first
    if s.mip && self.business_category.present?
      uri = 'http://' + s.mip
      xml_str = <<-EOF
        <?xml version="1.0" encoding="UTF-8" ?>
        <Package>
          <TranCode>#{s.trans_code}</TranCode>
          <InstNo>#{s.inst_no}</InstNo>
          <BizType>#{self.business_category.number}</BizType>
          <TermNo>#{s.term_no}</TermNo>
        </Package>
      EOF
      xml_data = Nokogiri::XML(xml_str)

      begin
        # RestClient.post s.mip, xml_data, :content_type => 'application/xml' { |response, request, result|
        RestClient.get s.mip  { |response, request, result|
          case response.code
          when 200
            response
          else
            errors.add(:id_number, "failed to get appointment from machine")
          end
        }
      rescue Exception
        errors.add(:id_number, "failed to get appointment from machine")
      end
    else
      errors.add(:id_number, "failed to get appointment from machine")
    end
  end

  def upcase_id_number
    self.id_number = id_number&.upcase
  end
end
