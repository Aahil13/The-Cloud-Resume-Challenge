describe("TEST API", () => {
  it("Should return an updated value and update the database", () => {
    // Make a request to your API endpoint
    cy.request(
      "https://n2j0ubj5wl.execute-api.us-east-1.amazonaws.com/default/resume_counter"
    ).then((response) => {
      // Verify the response status code
      expect(response.status).to.equal(200);

      // Verify that the response has the expected JSON structure
      expect(response.body).to.have.property("N");

      // Parse the 'N' property value to extract the numeric value
      const numericValue = parseInt(response.body.N);

      // Verify that the 'N' property is a number
      expect(numericValue).to.be.a("number");
    });
  });
});
