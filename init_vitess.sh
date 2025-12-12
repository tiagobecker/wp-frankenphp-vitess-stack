#!/bin/sh

echo "🚀 Iniciando inicialização do Vitess..."

# Aguardando vtgate
echo "⏳ Aguardando VTGate (host: vtgate port: 15306)..."
while ! nc -z vtgate 15306; do
    echo "Aguardando VTGate..."
    sleep 3
done

echo "✅ VTGate disponível!"

# Criar DB e usuário
echo "📌 Criando base de dados e usuário..."
mysql -h vtgate -P 15306 -u root -prootpass <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
EOF

echo "✅ Banco e usuário criados!"

# Aplicar VSchema
echo "📌 Aplicando VSchema..."
vtctldclient ApplyVSchema -ks=wordpress -vschema="$(cat /app/vschema.json)"

echo "🎉 Vitess inicializado com sucesso!"
exit 0
