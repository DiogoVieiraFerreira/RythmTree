#https://tools.ietf.org/html/rfc6455
class WSConnection
    attr_reader :id, :session, :key

    OPCODES = {
        "0": "Continuation",
        "1": "Text",
        "2": "Binary",
        "8": "Connection Close",
        "9": "Ping",
        "10": "Pong"
    }
    SUPPORTED_OPCODES = [1, 8]

    public
    def initialize session:, ws_key:
        @id = gen_uuid
        @session = session
        @key = ws_key
        @evt_call_backs = {}
        @status = "open"

        puts "ws_key #{ws_key}"
        puts "session #{session}"
        

        #listener
        @thread = Thread.new{
            puts "thread handling connection id #{@id} (key: #{@ws_key})"
            handleConnection
        }
    end

    def on_msg_register #+yield
        evt_id = gen_uuid
        @evt_call_backs[evt_id] = lambda{
            |data|
            yield data
        }
    end
    def on_msg_unregister evt_id
        @evt_call_backs.delete(evt_id)
    end

    def send_message body
        puts "send_message body:#{body}"
        puts "body size:#{body.size}"
        #header
        fin = 1
        opcode = 1
        header_byte = (fin * 128) + (opcode)

        #payload header
        #mask
        has_mask = 0 #develop that if you want to encrypt data
        has_mask_val = has_mask * 128
        #length
        payload_header_array = [has_mask_val + body.size] # <126
        if body.size >= (2**16 - 1)#>16bit
            payload_header_array = [has_mask_val + 127] + to_base_array(body.size, 256, 8)
        elsif body.size >= 125 #>~7bit
            payload_header_array = [has_mask_val + 126] + to_base_array(body.size, 256, 2)
        end

        #response
        response_array = [header_byte] + payload_header_array + [body]
        puts response_pack_param_str = "CC#{payload_header_array.size}A#{body.size}"
        response = response_array.pack response_pack_param_str#writes 2 8-bit ints followed by body string (should be changed when supporting longer payloads)
        puts "response:->#{response}"
        begin
            @session.write response
        rescue => exception
            puts "error during send_message print"
        end
    end

    def close propagate = true
        if propagate && false
            fin = 1
            opcode = 8
            header_byte = (opcode * 128) + (opcode)
            @session.write [header_byte].pack "C"
        end
        puts("closing connection");
        @status = "closed"
        @session.close
        @thread.exit
    end

    private
    def handleConnection
        loop do
            #header
            header_byte = @session.getbyte
            fin = header_byte & 0b10000000
            rsv = header_byte & 0b01110000
            opcode = header_byte & 0b00001111
                # puts "ws header | fin: #{fin}, rsv: #{rsv}, opcode: #{opcode}"
            
            raise "ws currently only supports single frame payloads" unless fin
            raise "unsupported opcode #{opcode} -> \"#{OPCODES[opcode.to_s.to_sym]}\"" unless SUPPORTED_OPCODES.include? opcode

            return close(false) if opcode == 8 #connection close
            
            #payload header
            payload_header_byte = @session.getbyte
            has_mask = payload_header_byte & 0b10000000
            #length
            payload_initial_length = payload_header_byte & 0b01111111
            length_array = [payload_initial_length]
            length_array = 2.times.map {@session.getbyte} if payload_initial_length == 126
            length_array = 8.times.map {@session.getbyte} if payload_initial_length == 127
            payload_length = from_array_to_base(length_array, 256);

                # puts "ws payload header | has_mask: #{has_mask}, payload_length: #{payload_length} bytes"

            #masking key
            masking_key_array = 4.times.map{@session.getbyte}
                # puts "ws masking key #{masking_key_array}"

            #body
            masked_body_array = payload_length.times.map {@session.getbyte}
            unmasked_body_array = masked_body_array.each_with_index.map{
                |body_byte, index|
                mask_key_byte = masking_key_array[index % 4]
                body_byte ^ mask_key_byte #xor body byte with mask byte to unmask it
            }
            body = unmasked_body_array.pack('C*').force_encoding("utf-8") #encode array into 8-bit integers str then convert to utf8 str

            puts "ws body : #{body}"
            on_message body
            close
        end
    end
    def on_message data
        @evt_call_backs.keys.each{
            |call_back_key|
            @evt_call_backs[call_back_key].call data
        }
    end
end