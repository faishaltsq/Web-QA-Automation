import jenkins.model.*
import jenkins.security.*

def jenkins = Jenkins.getInstance()
def user = jenkins.getUser("admin")
if (user != null) {
    def prop = user.getProperty(jenkins.security.ApiTokenProperty.class)
    if (prop == null) {
        prop = new jenkins.security.ApiTokenProperty()
        user.addProperty(prop)
    }
    def store = prop.getTokenStore()
    store.generateNewToken("automation-api-token")
    user.save()
    println "API token created for admin user"
} else {
    println "Admin user not found"
}