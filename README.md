# TERM-AI

<p align="center">
  <img src="assets/term-ai-banner.png" alt="term-ai - Asistente de terminal con IA" width="25%">
</p>

Asistente de inteligencia artificial para la terminal, desarrollado en Bash y conectado a la API de Groq.

Incluye dos comandos: `?` para consultas rápidas y `??` para mantener una conversación interactiva con contexto. Ambos permiten trabajar desde la terminal sin abrir un navegador.

## Características

- **Consultas rápidas:** obtené respuestas breves con `?`.
- **Chat interactivo:** mantené una conversación con `??`.
- **Soporte para pipes:** enviá la salida de comandos, logs o archivos como contexto.
- **Historial de conversación:** el chat conserva el contexto durante la sesión.
- **Markdown:** renderizado opcional con Glow.
- **Configuración sencilla:** API key y modelo configurables.
- **Ligero:** Bash, `curl` y `jq`, sin SDK ni entorno de ejecución adicional.

## Requisitos

- Bash.
- `curl`.
- `jq`.
- Una API key de Groq.
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

Opcionalmente, configurá el modelo:

```bash
export GROQ_MODEL="openai/gpt-oss-20b"
```

Protegé el archivo:

```bash
chmod 600 ~/.config/ask/env
```

La API key debe mantenerse privada y nunca debe subirse al repositorio.

## Uso

### 1. Consultas rápidas

El comando `?` responde una pregunta y termina.

```bash
? como ver los containers levantados
? como ver los logs de Docker en tiempo real
? como ejecutar las seeds de Laravel
? diferencia entre docker compose up y start
```

No necesitás escribir comillas alrededor de la pregunta.

### 2. Chat interactivo

Ejecutá `??` para abrir una conversación:

```bash
??
```

También podés comenzar directamente con una pregunta:

```bash
?? explicame como funciona Traefik
```

Una vez dentro del chat, podés hacer preguntas de seguimiento y la IA conservará el contexto de la sesión.

Comandos disponibles:

| Comando | Acción |
|---|---|
| `/salir` | Finaliza el chat |
| `/limpiar` | Reinicia el historial de conversación |

### 3. Enviar la salida de un comando

Podés enviar la salida de cualquier comando a una consulta rápida:

```bash
docker ps -a | ask explicame qué containers están detenidos
```

También podés iniciar un chat con esa información:

```bash
docker ps -a | ?? explicame qué containers están detenidos
```

El chat utiliza la salida como contexto inicial y permite continuar haciendo preguntas.

Otros ejemplos:

```bash
docker compose logs --tail=50 app | ?? identificá el error
```

```bash
cat docker-compose.yml | ?? explicame esta configuración
```

```bash
systemctl --failed | ?? explicame qué servicios fallaron
```

**Importante:** el soporte para pipes requiere que el script lea la entrada estándar antes de iniciar la conversación y luego recupere el teclado interactivo mediante `/dev/tty`. Por eso, el modo de chat está pensado para ejecutarse desde una terminal interactiva.

Revisá los datos antes de enviarlos a la API. Los logs y archivos pueden contener contraseñas, tokens, información personal u otros datos sensibles.

## Estructura del proyecto

```text
term-ai/
├── bin/
│   ├── ask
│   └── chat
├── install.sh
├── uninstall.sh
├── .gitignore
├── LICENSE
└── README.md
```

| Archivo | Descripción |
|---|---|
| `bin/ask` | Consultas rápidas a Groq |
| `bin/chat` | Chat interactivo con contexto y soporte para pipes |
| `install.sh` | Instalación de comandos, dependencias y alias |
| `uninstall.sh` | Desinstalación de los componentes |
| `.gitignore` | Exclusión de archivos sensibles y locales |

## Dependencias

### Glow (opcional)

Glow permite visualizar respuestas Markdown con colores y bloques de código en la terminal.

En Ubuntu, instalalo siguiendo las instrucciones oficiales de [Charm](https://github.com/charmbracelet/glow).

Si Glow no está instalado, los scripts pueden mostrar las respuestas como texto plano.

## API y modelos

Por defecto, los scripts utilizan la API compatible con OpenAI de Groq:

```text
https://api.groq.com/openai/v1/chat/completions
```

El modelo predeterminado es `openai/gpt-oss-20b`. Podés cambiarlo por otro modelo disponible en tu cuenta.

La disponibilidad, los límites de solicitudes y las cuotas gratuitas dependen de Groq y pueden cambiar.

Documentación:

- [Groq Console](https://console.groq.com/)
- [Groq API — Chat Completions](https://console.groq.com/docs/api-reference#chat-create)
- [Modelos disponibles](https://console.groq.com/docs/models)
- [Límites de uso](https://console.groq.com/docs/rate-limits)

## Seguridad

- No guardes API keys dentro del repositorio.
- No incluyas credenciales en los archivos de ejemplo.
- Protegé `~/.config/ask/env` con permisos `600`.
- Evitá enviar archivos completos de configuración o logs sensibles sin revisarlos.
- Recordá que las consultas y el contexto enviados mediante la API se procesan en la infraestructura del proveedor.

## Desarrollo

Los scripts están escritos en Bash y utilizan herramientas estándar de Unix.

Para probar cambios localmente:

```bash
bash bin/ask "como ver los containers de Docker"
bash bin/chat
```

Para probar el soporte de pipes:

```bash
printf 'Error: connection refused\n' | bash bin/chat "analizá este error"
```

## Licencia

Este proyecto se distribuye bajo la licencia definida en el archivo `LICENSE`.

