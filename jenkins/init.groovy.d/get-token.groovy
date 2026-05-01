import jenkins.model.*
import jenkins.security.*

def jenkins = Jenkins.getInstance()
def user = jenkins.getUser("admin")
if (user != null) {
    def prop = user.getProperty(jenkins.security.ApiTokenProperty.class)
    if (prop != null) {
        def store = prop.getTokenStore()
        // Generate new token and print it
        def token = store.generateNewToken("automation-api-token-2")
        user.save()
        println "NEW_TOKEN:" + token.getPlainToken()
    }
}