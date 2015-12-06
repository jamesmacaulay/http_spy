import {Socket} from "deps/phoenix/web/static/js/phoenix"

const socket = new Socket("/socket", {
  params: {token: window.userToken},
  logger: (kind, msg, data) => {
    if (window.LOG_TO_CONSOLE) {
      console.log(`${kind}: ${msg}`, data)
    }
  }
});

export default socket
