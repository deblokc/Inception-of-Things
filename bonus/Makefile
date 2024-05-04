NAME = IoT

$(NAME) :
		(cd scripts && ./prepare.sh && ./deploy.sh)

all :		$(NAME)

clean :	
		sudo k3d cluster delete IoT

fclean : 	clean
		rm -rf ./scripts/repo/

re : 		fclean all

vagrant :
		vagrant up

vagrant-clean :
		vagrant halt

vagrant-fclean :
		vagrant destroy -f

vagrant-re :	vagrant-fclean vagrant

.PHONY: $(NAME) all clean fclean re vagrant vagrant-clean vagrant-fclean vagrant-re
