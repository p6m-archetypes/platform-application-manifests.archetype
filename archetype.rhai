let context = #{};

const PROGRAMMING_CASES = CasedIdentityCasedValue([PascalCase, CamelCase, KebabCase, SnakeCase, TrainCase, ConstantCase]);

context += prompt("Project Prefix:", "project-prefix", #{
    placeholder: "Transaction",
    help: "Project Name",
    cases: [
        PROGRAMMING_CASES,
    ],
});

context += prompt("Project Suffix:", "project-suffix", #{
    type: Select(["Service", "Orchestrator", "Adapter", "Assessor", "Domain Gateway", "Frontend"]),
    help: "Project Type",
    defaults_with: "Service",
    cases: [
        PROGRAMMING_CASES,
    ],
});

if context.project_suffix == "service" {
  context += prompt("Persistence:", "persistence", #{
      type: Select(["CockroachDB", "None"]),
      help: "Persistence",
      defaults_with: "CockroachDB",
  });
}

context += set("artifact-id", render("{{ project-prefix }}_{{ project-suffix }}", context), #{
    cased_as: [
        PROGRAMMING_CASES
    ],
});

switch context["project-suffix"] {
    "domain-gateway" => context["service-protocol"]="GraphQL",
    "frontend" => context["service-protocol"]="REST",
    _ => context["service-protocol"]="gRPC",
}

Directory("contents").render(context);
