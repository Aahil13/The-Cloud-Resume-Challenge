fetch(
  "https://3qqqms7xul.execute-api.us-east-1.amazonaws.com/dev/resume_visitor_counter",
  {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  }
)
  .then((response) => response.json())
  .then((data) => {
    var count = data.visitor_count.N;
    document.getElementById("visitor-count-element").textContent = count;
  })
  .catch((error) => {
    console.error("Error fetching visitor count:", error);
  });
