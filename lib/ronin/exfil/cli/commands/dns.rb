# frozen_string_literal: true
#
# ronin-exfil - A Ruby CLI utility for receiving exfiltrated data.
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-exfil is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-exfil is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-exfil.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/exfil/cli/command'
require 'ronin/exfil/dns'

require 'ronin/core/cli/logging'

module Ronin
  module Exfil
    class CLI
      module Commands
        #
        # Starts a DNS server for receiving exfiltrated data.
        #
        # ## Usage
        #
        #     ronin-exfil dns [options] DOMAIN
        #
        # ## Options
        #
        #     -H, --host IP                    The interface to listen on (Default: 0.0.0.0)
        #     -p, --port PORT                  The port to listen on (Default: 53)
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     DOMAIN                           The domain to receive queries for
        #
        class Dns < Command

          include Core::CLI::Logging

          usage '[options] DOMAIN'

          option :host, short: '-H',
                        value: {
                          type:    String,
                          usage:   'IP',
                          default: '0.0.0.0'
                        },
                        desc: 'The interface to listen on'

          option :port, short: '-p',
                        value: {
                          type:    Integer,
                          usage:   'PORT',
                          default: 53
                        },
                        desc: 'The port to listen on'

          argument :domain, required: true,
                            desc:     'The domain to receive queries for'

          description 'Starts a DNS server for receiving exfiltrated data'

          man_page 'ronin-exfil-dns.1'

          #
          # Runs the `ronin-exfil dns` command.
          #
          # @param [String] domain
          #   The `DOMAIN` argument.
          #
          def run(domain)
            Ronin::Exfil::DNS.listen(domain,**proxy_kwargs) do |query_type,query_value|
              log_info "Received DNS query: #{query_type} #{query_value}"
            end
          end

          #
          # Maps options to keyword arguments for `Ronin::Exfil::DNS.listen`.
          #
          # @return [Hash{Symbol => Object}]
          #
          def proxy_kwargs
            {
              host: options[:host],
              port: options[:port]
            }
          end

        end
      end
    end
  end
end
