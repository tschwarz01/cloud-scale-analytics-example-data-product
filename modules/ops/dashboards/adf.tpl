{
    "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "position": {
                        "x": 0,
                        "y": 0,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [{
                            "name": "options",
                            "isOptional": true
                        }, {
                            "name": "sharedTimeRange",
                            "isOptional": true
                        }],
                        "type": "Extension/HubsExtension/PartType/MonitorChartPart",
                        "settings": {
                            "content": {
                                "options": {
                                    "chart": {
                                        "metrics": [{
                                            "resourceMetadata": {
                                                "id": "${data_factory_scope}"
                                            },
                                            "name": "PipelineFailedRuns",
                                            "aggregationType": 1,
                                            "namespace": "microsoft.datafactory/factories",
                                            "metricVisualization": {
                                                "displayName": "Failed pipeline runs metrics",
                                                "resourceDisplayName": "${data_factory_name}"
                                            }
                                        }],
                                        "title": "Count Failed activity runs metrics for dataFactoryNamedataFactoryName",
                                        "titleKind": 1,
                                        "visualization": {
                                            "chartType": 2,
                                            "legendVisualization": {
                                                "isVisible": true,
                                                "position": 2,
                                                "hideSubtitle": false
                                            },
                                            "axisVisualization": {
                                                "x": {
                                                    "isVisible": true,
                                                    "axisType": 2
                                                },
                                                "y": {
                                                    "isVisible": true,
                                                    "axisType": 1
                                                }
                                            },
                                            "disablePinning": true
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                "1": {
                    "position": {
                        "x": 6,
                        "y": 0,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [{
                            "name": "options",
                            "isOptional": true
                        }, {
                            "name": "sharedTimeRange",
                            "isOptional": true
                        }],
                        "type": "Extension/HubsExtension/PartType/MonitorChartPart",
                        "settings": {
                            "content": {
                                "options": {
                                    "chart": {
                                        "metrics": [{
                                            "resourceMetadata": {
                                                "id": "dataFactoryScopedataFactoryScopedataFactoryScope"
                                            },
                                            "name": "PipelineSucceededRuns",
                                            "aggregationType": 1,
                                            "namespace": "microsoft.datafactory/factories",
                                            "metricVisualization": {
                                                "displayName": "Succeeded pipeline runs metrics",
                                                "resourceDisplayName": "dataFactoryNamedataFactoryNamedataFactoryName"
                                            }
                                        }],
                                        "title": "Sum Succeeded pipeline runs metrics for dataFactoryNamedataFactoryNamedataFactoryName",
                                        "titleKind": 1,
                                        "visualization": {
                                            "chartType": 2,
                                            "legendVisualization": {
                                                "isVisible": true,
                                                "position": 2,
                                                "hideSubtitle": false
                                            },
                                            "axisVisualization": {
                                                "x": {
                                                    "isVisible": true,
                                                    "axisType": 2
                                                },
                                                "y": {
                                                    "isVisible": true,
                                                    "axisType": 1
                                                }
                                            },
                                            "disablePinning": true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        },
        "metadata": {
            "model": {}
        }
    }
}