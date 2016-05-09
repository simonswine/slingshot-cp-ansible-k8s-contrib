// vim: et:ts=4:sw=4:ft=groovy
def utils = new io.jetstack.Utils()
node('docker'){
    catchError {
        def imageName = 'simonswine/slingshot-cp-ansible-k8s-contrib'
        def imageTag = 'jenkins-build'

        jenkinsSlack('start')

        stage 'Checkout source code'
        checkout scm

        stage 'Build docker image'
        sh "docker build -t ${imageName}:${imageTag} ."

        if (onMasterBranch()) {
            stage 'Push docker image'


            withCredentials([[$class: 'FileBinding', credentialsId: '31a54b99-cab6-4a1a-9bd7-4de5e85ca0e6', variable: 'DOCKER_CONFIG_FILE']]) {
                try {
                    // prepare docker auth
                    sh 'mkdir -p _temp_dockercfg'
                    sh 'ln -sf \$DOCKER_CONFIG_FILE _temp_dockercfg/config.json'

                    // get tags to push
                    def imageTags = imageTags()
                    echo "tags to push '${imageTags}'"

                    def desc = []
                    for (i = 0; i < imageTags.size(); i++) {
                        def repoNameTag = "${imageName}:${imageTags[i]}"
                        echo "Push and tag ${repoNameTag}"
                        sh "docker tag ${imageName}:${imageTag} ${repoNameTag}"
                        sh "docker --config=_temp_dockercfg push ${repoNameTag}"
                        desc << "${repoNameTag}"
                    }

                    currentBuild.description = desc.join("\n") + "\ngit_commit=${gitCommit().take(8)}"
                } finally {
                    sh 'rm -rf _temp_dockercfg'
                }
            }
        }
    }
    jenkinsSlack('finish')
    step([$class: 'Mailer', recipients: 'christian@jetstack.io', notifyEveryUnstableBuild: true])
}
