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
                        "inputs": [],
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
                                            "aggregationType": 7,
                                            "namespace": "microsoft.datafactory/factories",
                                            "metricVisualization": {
                                                "displayName": "Failed pipeline runs metrics",
                                                "resourceDisplayName": "${data_factory_name}"
                                            }
                                        }],
                                        "title": "Count Failed pipeline runs metrics for ${data_factory_name}",
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
                        "colSpan": 6,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/MonitorChartPart",
                        "settings": {
                            "content": {
                                "options": {
                                    "chart": {
                                        "metrics": [{
                                            "resourceMetadata": {
                                                "id": "${data_factory_scope}"
                                            },
                                            "name": "PipelineSucceededRuns",
                                            "aggregationType": 1,
                                            "namespace": "microsoft.datafactory/factories",
                                            "metricVisualization": {
                                                "displayName": "Succeeded pipeline runs metrics",
                                                "resourceDisplayName": "${data_factory_name}"
                                            }
                                        }],
                                        "title": "Sum Succeeded pipeline runs metrics for ${data_factory_name}",
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
        }
    }

}