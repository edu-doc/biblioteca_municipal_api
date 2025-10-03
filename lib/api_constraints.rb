class ApiConstraints

    attr_accessor :version, :default

    def initialize(options)
        @version = options[:version]
        @default = options[:default]
    end

    def matches?(request)
        @default || request.headers['Accept'].include?("application/vnd.biblioteca_municipal_api.v#{@version}")
    end
end