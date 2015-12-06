import {Socket} from "deps/phoenix/web/static/js/phoenix"

const socket = new Socket("/socket", {
  params: {token: window.userToken},
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) }
});

export default socket
