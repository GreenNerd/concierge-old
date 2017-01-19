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
      RestClient.post url, xml_str, :content_type => 'application/xml' {|response, request, result|
        case response.code
        when 200
          Hash.from_xml result
        else
          false
        end
      }
    resuce
      false
    end
  end
end
