import socket
import threading

IP = '0.0.0.0'
PORT = 9998


def main():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((IP,PORT))
    # max connections of 5
    server.listen(5)

    print(f'LISTENING ON {IP}:{PORT}')

    while True:
        client, addr = server.accept()
        print(f' ACCEPTED CONNECTION FROM {addr[0]}:{addr[1]}'
        client_handler = threading.Thread(target=handle_client, args=(client,))
        client_handler.start()

def handle_client(client_socket):
    with client_socket as sock:
        request = sock.recv(1024)
        print(f' RECIEVED: {request.decode("utf-8")}')
        sock.send(b'ACK')

if __name__ == '__main__':
    main()
