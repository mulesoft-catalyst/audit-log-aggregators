%dw 2.0
output application/java

var reducedOrg = (org) -> {
    id: org.id,
    name: org.name
}

var getOrgAndSubOrgs = (payload) -> (
    [reducedOrg(payload)] ++ flatten(payload.subOrganizations map getOrgAndSubOrgs($))
)

var ignoredBusinessGroups = Mule::p('anypoint.platform.ignoredBusinessGroups') splitBy ","
---
getOrgAndSubOrgs(payload) filter ((item, index) ->  
    !(ignoredBusinessGroups contains item.id) 
)