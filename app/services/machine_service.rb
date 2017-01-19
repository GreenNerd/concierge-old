require 'nokogiri'
require 'rest-client'

class MachineService
  def initialize(params)
    @TranCode = params[:trans_code]
    @InstNo = params[:inst_no]
    @BizType = params[:biz_type]
    @TermNo = params[:term_no]
  end

  def appoint
    xml_str = <<-EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <Package>
        <TranCode>#{@TranCode}</TranCode>
        <InstNo>#{@InstNo}</InstNo>
        <BizType>#{@BizType}</BizType>
        <TermNo>#{@TermNo}</TermNo>
      </Package>
    EOF
    url = 'http://' + Setting.first.mip + ":8080/QueueServer/1.0/Services/createNumber"
    begin
      res = RestClient.post url, xml_str, content_type: :xml
    rescue Exception
      return false
    end
    if res.code == 200
      return Hash.from_xml(res.body)
    else
      return false
    end
  end
end
