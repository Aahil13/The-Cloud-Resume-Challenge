fetch(
  "https://n2j0ubj5wl.execute-api.us-east-1.amazonaws.com/default/resume_counter",
  {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  }
)
  .then((response) => response.json())
  .then((data) => {
    var count = data.N;
    let editedText = count == 1 ? "1 visitor" : count + " visitors";
    document.getElementById("visitor-count-element").textContent = editedText;
  })
  .catch((error) => {
    console.error("Error fetching visitor count:", error);
  });
