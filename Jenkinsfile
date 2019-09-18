pipeline{
	agent{
		node{
			label 'master'
		}
	}
	stages{
		stage('terraform started'){
			steps{
				sh 'echo "Started...!" '
			}
		}
		stage('git clone'){
			steps{
				sh 'sudo rm -rf *;sudo git clone https://github.com/kowshik48/cappoc1_destroy.git'
			}
		}
		stage('tfsvars create'){
			steps{
				sh 'sudo cp /var/lib/jenkins/workspace/Infra_Terraform_Pipeline/cappoc1/*  /var/lib/jenkins/workspace/Infra_Terraform_Pipeline_destroy/cappoc1_destroy/'
				sh 'cd /var/lib/jenkins/workspace/Infra_Terraform_Pipeline_destroy/cappoc1_destroy/'
			}
		}
		stage('terraform init'){
			steps{
				sh 'cd /var/lib/jenkins/workspace/Infra_Terraform_Pipeline_destroy/cappoc1_destroy/ ; sudo terraform init /var/lib/jenkins/workspace/Infra_Terraform_Pipeline_destroy/cappoc1_destroy/'
			}
		}
		stage('terraform destroy'){
			steps{
			sh 'sudo terraform destroy -no-color -auto-approve /var/lib/jenkins/workspace/Infra_Terraform_Pipeline_destroy/cappoc1_destroy/'
			sh 'sudo rm -f /var/lib/jenkins/workspace/Infra_Terraform_Pipeline_destroy/cappoc1_destroy/*'
			}
		}
		stage('terraform ended'){
			steps{
				sh 'echo "Ended.......!" '
			}
		}
		
	}
}
