require 'rest-client'

class MachineService
  TRAN_CDOE = {
    create_number: '694012',
    numbercount: '694016',
    servingnumber: '694018',
    passcount: '694017'
  }.freeze

  def initialize
    @inst_no = Setting.instance.inst_no
    @term_no = Setting.instance.term_no
  end

  def create_number(biz_type)
    payload = pack_payload(tran_code: TRAN_CDOE[:create_number],
                           inst_no: @inst_no,
                           biz_type: biz_type,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/createNumber"

    post_with(url, payload)
  end

  # get the the total of appointment number of the day
  def number_count(biz_type)
    payload = pack_payload(tran_code: TRAN_CDOE[:numbercount],
                           biz_type: biz_type,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/numbercount"

    post_with(url, payload)
  end

  # get the service terminal serving number
  def serving_number(biz_type, serv_counter)
    payload = pack_payload(tran_code: TRAN_CDOE[:servingnumber],
                           biz_type: biz_type,
                           serv_counter: serv_counter,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/servingnumber"

    post_with(url, payload)
  end

  # get the passed appointment number the day
  def pass_count(biz_type)
    payload = pack_payload(tran_code: TRAN_CDOE[:passcount],
                           biz_type: biz_type,
                           term_no: @term_no)

    url = "#{Setting.instance.mip}/QueueServer/1.0/Services/passcount"

    post_with(url, payload)
  end

  private

  def post_with(url, payload, retries: 3)
    begin
      rsp = RestClient::Request.execute method: :post, url: url, payload: payload, headers: { content_type: :xml }, timeout: 5

      if rsp.code == 200
        rsp_hsh = Hash.from_xml(rsp.body)
                      .deep_transform_keys { |key| key.to_s.underscore.to_sym }
        return rsp_hsh if rsp_hsh.dig(:package, :rsp_code) == '0'.freeze
      end
    rescue => e
      Rails.logger.warn "MachineServiceError: #{retries} #{url}(#{e})"

      retries -= 1

      if retries > 0
        retry
      else
        return
      end
    end
  end

  def pack_payload(hsh)
    hsh.transform_keys { |key| key.to_s.camelize }.to_xml(root: :Package,
                                                          skip_types: true)
  end
end
