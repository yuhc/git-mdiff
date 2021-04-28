require 'json'
require 'net/http'
require "resolv"


# https://docs.github.com/en/github/authenticating-to-github/about-githubs-ip-addresses
def github_ip_ranges()
    uri = URI("https://api.github.com/meta")
    response = Net::HTTP.get(uri)
    github_ips = JSON.parse(response)

    return github_ips["hooks"]
end


# https://support.atlassian.com/organization-administration/docs/ip-addresses-and-domains-for-atlassian-cloud-products/
def bitbucket_ip_ranges()
    uri = URI("https://ip-ranges.atlassian.com")
    response = Net::HTTP.get(uri)
    bitbucket_ips = JSON.parse(response)

    selected_ips = []
    for item in bitbucket_ips["items"]
        if item["network"] =~ Resolv::IPv4::Regex
            selected_ips.push(item["cidr"])
        end
    end

    return selected_ips
end
