require 'rest-client'

class MachineService
  def initialize
    @tran_code = Setting.instance.tran_code
    @inst_no = Setting.instance.inst_no
    @term_no = Setting.instance.term_no
  end

  def create_number(biz_type)
    payload = pack_payload(tran_code: @tran_code,
                           inst_no: @inst_no,
                           biz_type: biz_type,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/createNumber"

    get_post_result(url, payload)
  end

  # get the the total of appointment number of the day
  def number_count(biz_type)
    payload = pack_payload(tran_code: @tran_code,
                           biz_type: biz_type,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/numbercount"

    get_post_result(url, payload)
  end

  # get the service terminal serving number
  def serving_number(biz_type, serv_counter)
    payload = pack_payload(tran_code: @tran_code,
                           biz_type: biz_type,
                           serv_counter: serv_counter,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/servingnumber"

    get_post_result(url, payload)
  end

  private

  def get_post_result(url, payload)
    begin
      resp = RestClient.post url, payload, content_type: :xml

      if resp.code == 200
        resp_hsh = Hash.from_xml(resp.body)
                       .deep_transform_keys { |key| key.to_s.underscore.to_sym }
        return resp_hsh if resp_hsh.dig(:package, :rsp_code) == '0'.freeze
      end
    rescue
      nil
    end
  end

  def pack_payload(hsh)
    hsh.transform_keys { |key| key.to_s.camelize }.to_xml(root: :Package,
                                                          skip_types: true)
  end
end
