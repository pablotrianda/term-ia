# TERM-AI

<p align="center">
  <img src="assets/term-ai-banner.png" alt="term-ai - Asistente de terminal con IA" width="50%">
</p>

Asistente de inteligencia artificial para la terminal, desarrollado en Bash y conectado a la API de Groq. Permite consultar información, mantener conversaciones con contexto y administrar tareas de diagnóstico en Linux desde la terminal, sin necesidad de abrir un navegador.

## Características

- **Consultas rápidas:** obtené respuestas breves con `?`.
- **Chat interactivo:** mantené una conversación con `??`.
- **Agente de sistema:** consultá el estado de Linux y ejecutá acciones autorizadas con `??!`.
- **Soporte para pipes:** enviá salidas de comandos, logs y archivos como contexto.
- **Contexto conversacional:** conservá el historial durante la sesión.
- **Herramientas nativas:** el agente utiliza llamadas a herramientas de la API de Groq.
- **Seguridad:** las acciones que modifican el sistema requieren confirmación.
- **Markdown:** renderizado opcional con Glow.
- **Ligero:** Bash, `curl` y `jq`, sin SDK ni entorno de ejecución adicional.

## Requisitos

- Bash.
- `curl`.
- `jq`.
- Una API key de Groq.
- Una terminal interactiva para utilizar el chat y el agente.
- `sudo` para las operaciones administrativas que lo requieran.
- Glow, opcional para visualizar Markdown con formato.

## Instalación

Cloná el repositorio:

```bash
git clone URL_DE_TU_REPOSITORIO term-ai
cd term-ai
```

Ejecutá el instalador:

```bash
chmod +x install.sh
./install.sh
```

El instalador copia los comandos a `~/.local/bin/`, configura los alias en `~/.bashrc` y crea el archivo de configuración si todavía no existe.

Recargá la configuración de Bash:

```bash
source ~/.bashrc
```

Asegurate de que `~/.local/bin` esté incluido en tu `PATH`.

## Configuración

Creá una API key desde [Groq Console](https://console.groq.com/keys).

Editá el archivo de configuración:

```bash
nano ~/.config/ask/env
```

Agregá tu clave:

```bash
export GROQ_API_KEY="TU_API_KEY"
```

Configurá el modelo opcionalmente:

```bash
export GROQ_MODEL="openai/gpt-oss-20b"
```

También podés cambiar la URL de la API mediante `GROQ_API_URL`, si necesitás utilizar otro endpoint compatible.

Protegé el archivo:

```bash
chmod 600 ~/.config/ask/env
```

La API key debe mantenerse privada y nunca debe subirse al repositorio.

## Uso

### 1. Consultas rápidas: `?`

El comando `?` responde una pregunta y termina.

```bash
? como ver los containers levantados
? como ver los logs de Docker en tiempo real
? como ejecutar las seeds de Laravel
? diferencia entre docker compose up y start
```

No necesitás escribir comillas alrededor de la pregunta.

### 2. Chat interactivo: `??`

Abrí una conversación:

```bash
??
```

También podés comenzar directamente con una pregunta:

```bash
?? explicame como funciona Traefik
```

Durante la conversación podés realizar preguntas de seguimiento y utilizar el contexto acumulado.

Comandos disponibles:

| Comando | Acción |
|---|---|
| `/salir` | Finaliza el chat |
| `/limpiar` | Reinicia el historial, si está implementado en la versión instalada |

### 3. Agente de sistema: `??!`

El agente permite consultar información del sistema y realizar determinadas operaciones administrativas mediante herramientas explícitamente implementadas en el script.

Ejemplos:

```bash
??! revisá el estado del sistema y el espacio en disco
??! mostrame los procesos que más CPU consumen
??! listá los contenedores Docker
??! revisá el estado de nginx
??! mostrame los últimos 50 logs de docker.service
```

También podés iniciar el agente directamente desde el script:

```bash
bash bin/agent "revisá el estado del sistema"
```

#### Herramientas disponibles

| Herramienta | Función |
|---|---|
| `system_info` | Información del sistema operativo y uptime |
| `processes` | Lista de procesos con mayor consumo de CPU |
| `disk_usage` | Espacio disponible en discos |
| `memory` | Uso de memoria |
| `docker_ps` | Lista de contenedores Docker |
| `docker_logs` | Consulta logs de un contenedor |
| `service_status` | Consulta el estado de un servicio systemd |
| `service_logs` | Consulta logs de un servicio systemd |
| `read_file` | Lee determinados archivos informativos permitidos |
| `service_action` | Inicia, detiene o reinicia un servicio |
| `signal_process` | Envía señales `TERM` o `KILL` a un proceso |

El conjunto de herramientas depende de la versión instalada del agente.

#### Confirmación de acciones

Las operaciones administrativas implementadas solicitan confirmación antes de ejecutarse:

```text
Acción solicitada: systemctl restart nginx.service
¿Autorizar? [s/N]
```

Solo se autoriza la operación al responder `s` o `S`. Cualquier otra respuesta cancela la acción.

La confirmación no sustituye la revisión del comando: verificá siempre el servicio o proceso seleccionado antes de autorizar.

El agente no debe ejecutar comandos arbitrarios generados por el modelo. Las operaciones permitidas están limitadas por las funciones implementadas en el script.

### 4. Enviar la salida de un comando mediante pipes

Podés enviar la salida de cualquier comando a una consulta rápida:

```bash
docker ps -a | ask explicame qué contenedores están detenidos
```

También podés iniciar un chat con esa información:

```bash
docker ps -a | ?? explicame qué contenedores están detenidos
```

Ejemplos adicionales:

```bash
docker compose logs --tail=50 app | ?? identificá el error
```

```bash
cat docker-compose.yml | ?? explicame esta configuración
```

```bash
systemctl --failed | ?? explicame qué servicios fallaron
```

Para el agente:

```bash
docker ps -a | ??! analizá el estado de los contenedores
```

El soporte para pipes requiere que el script lea la entrada estándar antes de iniciar la conversación y, cuando corresponda, recupere el teclado interactivo mediante `/dev/tty`. El chat y el agente están pensados para ejecutarse desde una terminal interactiva.

**Importante:** revisá los datos antes de enviarlos a la API. Los logs y archivos pueden contener contraseñas, tokens, información personal u otros datos sensibles.

## Estructura del proyecto

```text
term-ai/
├── assets/
│   └── term-ai-banner.png
├── bin/
│   ├── ask
│   ├── chat
│   └── agent
├── install.sh
├── uninstall.sh
├── .gitignore
├── LICENSE
└── README.md
```

| Archivo | Descripción |
|---|---|
| `assets/term-ai-banner.png` | Imagen de cabecera del proyecto |
| `bin/ask` | Consultas rápidas a Groq |
| `bin/chat` | Chat interactivo con contexto y soporte para pipes |
| `bin/agent` | Agente de sistema Linux con herramientas permitidas |
| `install.sh` | Instalación de comandos, dependencias y alias |
| `uninstall.sh` | Desinstalación de los componentes |
| `.gitignore` | Exclusión de archivos sensibles y locales |

## Dependencias opcionales

### Glow

Glow permite visualizar respuestas Markdown con colores y bloques de código en la terminal.

En Ubuntu, consultá las instrucciones oficiales de [Charm](https://github.com/charmbracelet/glow).

Si Glow no está instalado, los scripts pueden mostrar las respuestas como texto plano.

## API y modelos

Por defecto, los scripts utilizan la API compatible con OpenAI de Groq:

```text
https://api.groq.com/openai/v1/chat/completions
```

El modelo predeterminado es:

```text
openai/gpt-oss-20b
```

Podés configurar otro modelo disponible en tu cuenta mediante `GROQ_MODEL`.

El agente utiliza llamadas nativas a herramientas: la API devuelve las funciones solicitadas y el script ejecuta únicamente las que están implementadas en su lista permitida. La disponibilidad de modelos, las cuotas y los límites de solicitudes dependen de Groq y pueden cambiar.

Documentación:

- [Groq Console](https://console.groq.com/)
- [Groq API — Chat Completions](https://console.groq.com/docs/api-reference#chat-create)
- [Modelos disponibles](https://console.groq.com/docs/models)
- [Tool Use](https://console.groq.com/docs/tool-use)

## Seguridad

- No guardes API keys dentro del repositorio.
- No incluyas credenciales en los archivos de ejemplo.
- Protegé `~/.config/ask/env` con permisos `600`.
- Revisá los logs y archivos antes de enviarlos a Groq.
- No habilites ejecución arbitraria de comandos generados por el modelo.
- Validá los argumentos de cada herramienta antes de ejecutar operaciones.
- Solicitá autorización antes de modificar servicios o enviar señales a procesos.
- Recordá que las consultas y el contexto enviados mediante la API se procesan en la infraestructura del proveedor.

## Desarrollo

Los scripts están escritos en Bash y utilizan herramientas estándar de Unix.

Para probar cambios localmente:

```bash
bash -n bin/ask
bash -n bin/chat
bash -n bin/agent
```

Para probar las consultas rápidas y el chat:

```bash
bash bin/ask "cómo ver los contenedores Docker"
bash bin/chat
```

Para probar el agente:

```bash
bash bin/agent "revisá el estado del sistema y el espacio en disco"
```

Para probar el soporte de pipes:

```bash
printf 'Error: connection refused\n' | bash bin/chat "analizá este error"
```


